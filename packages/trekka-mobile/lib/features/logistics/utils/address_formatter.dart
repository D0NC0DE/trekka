/// Utilities for formatting addresses
class AddressFormatter {
  /// Shortens an address to the first 2 comma-separated parts
  /// e.g., "123 Main St, Lagos, Nigeria" -> "123 Main St, Lagos"
  static String shortenAddress(String address) {
    final parts = address.split(',');
    if (parts.length > 2) {
      return '${parts[0]}, ${parts[1].trim()}';
    }
    return address.trim();
  }

  /// Formats address with fallback
  static String formatWithFallback(String? address, String fallback) {
    if (address == null || address.trim().isEmpty) {
      return fallback;
    }
    return shortenAddress(address);
  }

  /// Returns only the first comma-separated portion of the address.
  static String? primaryLine(String? address) {
    if (address == null) return null;
    final trimmed = address.trim();
    if (trimmed.isEmpty) return null;
    final parts = trimmed.split(',');
    return parts.first.trim();
  }

  /// Returns the primary line of the address or the fallback if unavailable.
  static String primaryLineWithFallback(String? address, String fallback) {
    final primary = primaryLine(address);
    if (primary == null || primary.isEmpty) {
      return fallback;
    }
    return primary;
  }
}
