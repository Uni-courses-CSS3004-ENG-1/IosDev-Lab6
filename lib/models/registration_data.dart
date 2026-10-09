/// Roles a user can pick during registration.
enum UserRole {
  student('Student'),
  teacher('Teacher'),
  developer('Developer');

  const UserRole(this.label);

  final String label;
}

/// Snapshot of a successfully validated registration form.
class RegistrationData {
  const RegistrationData({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    required this.acceptedTerms,
  });

  final String fullName;
  final String email;
  final String password;
  final UserRole role;
  final bool acceptedTerms;

  /// Printable summary. The password is masked so it never hits the logs.
  @override
  String toString() {
    return 'RegistrationData(\n'
        '  fullName: $fullName,\n'
        '  email: $email,\n'
        '  password: ${'*' * password.length},\n'
        '  role: ${role.label},\n'
        '  acceptedTerms: $acceptedTerms\n'
        ')';
  }
}
