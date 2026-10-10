# Lab 6 — User Registration & Form Validation

Flutter (iOS) app with a multi-field **User Registration & Profile Setup** screen.

## Task
- `Form` + `GlobalKey<FormState>` with `TextFormField`s: Full Name, Email, Password, Confirm Password
- Real-time (`AutovalidateMode.onUserInteraction`) and submit-time validation with clear error text
- "I accept the Terms and Conditions" `Checkbox` — registration is blocked (red `SnackBar`) until it is checked
- Role `DropdownButtonFormField` (Student / Teacher / Developer)
- On valid submit: form data is printed to the terminal and a success `SnackBar` is shown

## Run
```bash
flutter pub get
flutter run        # pick an iOS simulator
flutter test       # widget tests
```
