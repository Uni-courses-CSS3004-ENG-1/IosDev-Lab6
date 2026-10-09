import 'package:flutter/material.dart';

import '../models/registration_data.dart';
import '../utils/validators.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _confirmPasswordFieldKey = GlobalKey<FormFieldState<String>>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  UserRole _role = UserRole.student;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Please fix the errors in the form.'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    final data = RegistrationData(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      role: _role,
      acceptedTerms: _acceptedTerms,
    );
    debugPrint('Registration successful:\n$data');

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Welcome, ${data.fullName}! Registration successful.'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Registration Successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${data.fullName}'),
            Text('Email: ${data.email}'),
            Text('Role: ${data.role.label}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                // Real-time validation: a field shows its error as soon as
                // the user has interacted with it.
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Profile Setup', style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      'Fill in your details to register.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const Key('nameField'),
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: Validators.fullName,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('emailField'),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'name@narxoz.kz',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('passwordField'),
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        helperText:
                            'At least ${Validators.minPasswordLength} characters',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? 'Show password'
                              : 'Hide password',
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      validator: Validators.password,
                      onChanged: (_) {
                        // Keep the "Passwords do not match" error in sync
                        // when the password changes after confirming it.
                        if (_confirmPasswordController.text.isNotEmpty) {
                          _confirmPasswordFieldKey.currentState?.validate();
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: _confirmPasswordFieldKey,
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_reset_outlined),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          tooltip: _obscureConfirmPassword
                              ? 'Show password'
                              : 'Hide password',
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          ),
                        ),
                      ),
                      validator: (value) => Validators.confirmPassword(
                        value,
                        _passwordController.text,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<UserRole>(
                      key: const Key('roleField'),
                      initialValue: _role,
                      decoration: const InputDecoration(
                        labelText: 'Role',
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        for (final role in UserRole.values)
                          DropdownMenuItem(
                            value: role,
                            child: Text(role.label),
                          ),
                      ],
                      onChanged: (role) {
                        if (role != null) setState(() => _role = role);
                      },
                    ),
                    const SizedBox(height: 8),
                    // Wrapped in a FormField so the Form's validate() also
                    // blocks registration until the box is checked.
                    FormField<bool>(
                      key: const Key('termsField'),
                      initialValue: _acceptedTerms,
                      validator: (accepted) => accepted == true
                          ? null
                          : 'You must accept the Terms and Conditions',
                      builder: (field) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckboxListTile(
                            value: field.value ?? false,
                            onChanged: (checked) {
                              field.didChange(checked);
                              setState(() => _acceptedTerms = checked ?? false);
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'I accept the Terms and Conditions',
                            ),
                          ),
                          if (field.hasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                field.errorText!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      key: const Key('registerButton'),
                      onPressed: _submit,
                      icon: const Icon(Icons.how_to_reg),
                      label: const Text('Register'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
