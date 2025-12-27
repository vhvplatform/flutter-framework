/// Advanced caching strategies
library advanced_cache;

import 'dart:async';
import 'dart:collection';

/// LRU (Least Recently Used) Cache
class LRUCache<K, V> {
  /// Creates an LRU cache
  /// 
  /// [maxSize] specifies the maximum number of entries (not bytes) allowed in cache
  LRUCache({required this.maxSize}) : assert(
    maxSize > 0, 
    'Cache size must be positive (maxSize represents maximum number of entries)',
  );

  /// Maximum cache size (number of entries)
  final int maxSize;

  final _cache = LinkedHashMap<K, _CacheEntry<V>>();

  /// Get value from cache
  V? get(K key) {
    final entry = _cache.remove(key);
    if (entry == null) return null;

    // Check if expired
    if (entry.isExpired) {
      return null;
    }

    // Move to end (most recently used)
    _cache[key] = entry;
    return entry.value;
  }

  /// Put value in cache
  void put(K key, V value, {Duration? ttl}) {
    _cache.remove(key);
    _cache[key] = _CacheEntry(
      value: value,
      expiresAt: ttl != null ? DateTime.now().add(ttl) : null,
    );

    // Evict if over size - use while loop for memory efficiency
    while (_cache.length > maxSize) {
      _cache.remove(_cache.keys.first);
    }
  }

  /// Check if key exists
  bool containsKey(K key) {
    return _cache.containsKey(key) && !_cache[key]!.isExpired;
  }

  /// Remove key
  V? remove(K key) {
    final entry = _cache.remove(key);
    return entry?.value;
  }

  /// Clear cache
  void clear() {
    _cache.clear();
  }

  /// Get cache size
  int get size => _cache.length;
  
  /// Get all keys
  Iterable<K> get keys => _cache.keys;
}

class _CacheEntry<V> {
  _CacheEntry({required this.value, this.expiresAt});

  final V value;
  final DateTime? expiresAt;

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
}

/// Multi-level cache (memory + disk simulation)
class MultiLevelCache<K, V> {
  /// Creates a multi-level cache
  MultiLevelCache({
    required this.l1Size,
    required this.l2Size,
    this.l1TTL = const Duration(minutes: 5),
    this.l2TTL = const Duration(hours: 1),
  }) {
    _l1Cache = LRUCache<K, V>(maxSize: l1Size);
    _l2Cache = LRUCache<K, V>(maxSize: l2Size);
  }

  /// L1 cache size (memory)
  final int l1Size;
  
  /// L2 cache size (disk simulation)
  final int l2Size;
  
  /// L1 time to live
  final Duration l1TTL;
  
  /// L2 time to live
  final Duration l2TTL;

  late LRUCache<K, V> _l1Cache;
  late LRUCache<K, V> _l2Cache;

  /// Get value from cache
  Future<V?> get(K key) async {
    // Try L1 first
    var value = _l1Cache.get(key);
    if (value != null) return value;

    // Try L2
    value = _l2Cache.get(key);
    if (value != null) {
      // Promote to L1
      _l1Cache.put(key, value, ttl: l1TTL);
      return value;
    }

    return null;
  }

  /// Put value in cache
  Future<void> put(K key, V value) async {
    _l1Cache.put(key, value, ttl: l1TTL);
    _l2Cache.put(key, value, ttl: l2TTL);
  }

  /// Clear all caches
  void clear() {
    _l1Cache.clear();
    _l2Cache.clear();
  }
}

/// Cache with automatic refresh
class RefreshableCache<K, V> {
  /// Creates a refreshable cache
  RefreshableCache({
    required this.fetcher,
    required this.maxSize,
    this.ttl = const Duration(minutes: 5),
    this.refreshThreshold = const Duration(minutes: 4),
  }) {
    _cache = LRUCache<K, V>(maxSize: maxSize);
  }

  /// Function to fetch data
  final Future<V> Function(K key) fetcher;
  
  /// Maximum cache size
  final int maxSize;
  
  /// Time to live
  final Duration ttl;
  
  /// Refresh before expiry
  final Duration refreshThreshold;

  late LRUCache<K, V> _cache;
  final Map<K, DateTime> _fetchTimes = {};
  final Map<K, Future<V>> _inFlight = {};

  /// Get value with automatic refresh
  Future<V> get(K key) async {
    final cached = _cache.get(key);
    
    if (cached != null) {
      final fetchTime = _fetchTimes[key];
      if (fetchTime != null) {
        final age = DateTime.now().difference(fetchTime);
        
        // Refresh in background if close to expiry
        if (age > refreshThreshold && !_inFlight.containsKey(key)) {
          _refreshInBackground(key);
        }
      }
      
      return cached;
    }

    // Not in cache, fetch it
    return _fetch(key);
  }

  Future<V> _fetch(K key) async {
    // Check if already fetching
    if (_inFlight.containsKey(key)) {
      return _inFlight[key]!;
    }

    final future = fetcher(key);
    _inFlight[key] = future;

    try {
      final value = await future;
      _cache.put(key, value, ttl: ttl);
      _fetchTimes[key] = DateTime.now();
      return value;
    } finally {
      _inFlight.remove(key);
    }
  }

  void _refreshInBackground(K key) {
    _fetch(key).catchError((_) {
      // Ignore errors in background refresh
    });
  }

  /// Clear cache
  void clear() {
    _cache.clear();
    _fetchTimes.clear();
  }
}
