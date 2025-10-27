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
}
