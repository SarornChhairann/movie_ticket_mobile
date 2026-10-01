/// Why the stored session was cleared by the network layer.
sealed class SessionEnd {
  const SessionEnd();
}

/// The access token expired and could not be refreshed.
final class SessionExpired extends SessionEnd {
  const SessionExpired();
}

/// The server answered `403 ACCOUNT_BLOCKED` to an authenticated call.
final class SessionBlocked extends SessionEnd {
  const SessionBlocked(this.message);

  final String message;
}
