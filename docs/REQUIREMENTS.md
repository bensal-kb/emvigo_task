# App Requirements

## 1. Overview

The app provides an authentication flow (Login / Signup) backed by Firebase Authentication
(email/password), a one-time profile-creation step completed right after signup whose data is
stored in Cloud Firestore, and a Home screen that displays the signed-in user's data once
authenticated.

## 2. Feature List

| Feature | Description |
|---|---|
| Login | Existing user signs in with email/password, or switches to Signup |
| Signup | New user registers with email/password |
| Create Profile | One-time profile setup shown immediately after a successful Signup |
| Home Page | Landing screen for authenticated users showing their Firestore profile data, with a Logout option |

## 3. Screen Specifications

### 3.1 Login

Per `designs/login.png`: headline "Welcome to TestApp", subtext "All users are verified to help
prevent fake accounts."

| Field | Type | Required |
|---|---|---|
| Email | Text (email) | Yes |
| Password | Text (masked) | Yes |

- **Actions:** "LOGIN" button; "Don't have account **Signup**" link.
- **Navigation:**
  - Login success → Home Page.
  - "Signup" link → Signup screen.

### 3.2 Signup

Per `designs/` "Create Account" mockup: headline "Create Account", same verification subtext as
Login.

| Field | Type | Required |
|---|---|---|
| Email | Text (email) | Yes |
| Password | Text (masked) | Yes |
| Confirm Password | Text (masked) | Yes |

- **Actions:** "SIGNUP" button; "Already have account, **SignIn**" link.
- **Navigation:**
  - Signup success → Create Profile.
  - "SignIn" link → Login screen.

### 3.3 Create Profile

Shown once, immediately after a successful Signup. Per `designs/create_account.png`: headline
"Create your Profile", subtext "Create your profile with some basic information", back arrow at
top-left. Fields are grouped under labels ("What's your Name", "What's your date of birth", etc.);
First/Last Name sit side by side with helper text "First name is only visible on your profile."

| Field | Type | Required |
|---|---|---|
| First Name | Text | Yes |
| Last Name | Text | Yes |
| Date of Birth | Date picker (dd-mm-yyyy) | Yes |
| Gender | Radio (Male / Female, per mockup) | Yes |
| Nationality | Dropdown | Yes |
| Languages | Dropdown | Yes |

- **Actions:** "Save" button (sentence case, not uppercase — differs from Login/Signup buttons).
- **Navigation:**
  - Save success → Home Page.

### 3.4 Home Page

- Displays the signed-in user's data (name, DOB, gender, nationality, languages) fetched from their
  Firestore profile document, alongside the existing placeholder Home widgets.
- **Actions:** "Logout" option.
- **Navigation:**
  - Logout → sign out of Firebase Auth, clear local session → Login screen.

## 4. User Flow

```
Login  ⇄  Signup
  │           │
  │           ▼
  │     Create Profile
  │           │
  ▼           ▼
       Home Page
           │
      (Logout)
           │
           ▼
        Login
```

## 5. Consolidated Field Specification

Validation rules below are reasonable defaults, not explicitly given — confirm before implementation.

| Screen | Field | Type | Required | Suggested Validation |
|---|---|---|---|---|
| Login | Email | Email | Yes | Valid email format |
| Login | Password | Masked text | Yes | Non-empty |
| Signup | Email | Email | Yes | Valid email format |
| Signup | Password | Masked text | Yes | Minimum length (e.g. 8 chars) |
| Signup | Confirm Password | Masked text | Yes | Must match Password |
| Create Profile | First Name | Text | Yes | Non-empty |
| Create Profile | Last Name | Text | Yes | Non-empty |
| Create Profile | Date of Birth | Date | Yes | Valid date, user must be a reasonable age |
| Create Profile | Gender | Radio | Yes | One option selected |
| Create Profile | Nationality | Dropdown | Yes | One option selected |
| Create Profile | Languages | Dropdown | Yes | One option selected |

## 6. Assumptions & Out of Scope

- Field layout is sourced from the visual mockups in `designs/` (login, signup/"Create Account", and
  "Create your Profile"), which supersede the original text spec: **Confirm Password belongs to
  Signup**, not Login.
- "Create Profile" is the single post-signup step; there is no separate "Create Password" screen.
- No "Forgot Password" flow is included in this spec.
- Gender options confirmed from mockup as Male / Female (radio). Nationality and Languages dropdown
  option lists are not fully specified — mockup shows "Indian" and "English" as example selections.

## 7. Mapping to Project Structure

Following this project's [FEATURE_GUIDE.md](FEATURE_GUIDE.md) convention (`lib/features/<name>/`
with `bloc/`, `view/`, `widgets/`):

| Screen(s) | Suggested feature folder |
|---|---|
| Login, Signup | `lib/features/auth/` (already scaffolded) |
| Create Profile | `lib/features/create_profile/` |
| Home Page | `lib/features/home/` |

## 8. Technical Architecture

### Authentication

- **Firebase Authentication**, email/password provider.
- Login → `FirebaseAuth.signInWithEmailAndPassword`.
- Signup → `FirebaseAuth.createUserWithEmailAndPassword`.
- Logout → `FirebaseAuth.signOut`.
- Per [ARCHITECTURE.md](ARCHITECTURE.md)'s repo pattern, Firebase Auth calls are wrapped behind an
  `AuthRepo` interface (`data/repo/`) / `AuthRepoImpl` (`data/repo_impl/`) — cubits never call
  `FirebaseAuth` directly, and results still surface as `Response<T>` / `Error` so `BaseState` /
  `StateWidget` handling stays consistent with the rest of the app.

### Data Storage

- **Cloud Firestore** stores the profile data collected on the Create Profile screen (First Name,
  Last Name, DOB, Gender, Nationality, Languages), keyed by the Firebase Auth UID.
- Exact collection/document layout (e.g. a `users` collection with one document per UID) is not
  otherwise specified — implementation detail for whoever builds the repo.
- Same repo-wrapping rule applies: a `UserRepo` / `UserRepoImpl` around Firestore reads/writes, not
  raw Firestore calls from cubits or widgets.
- Home Page reads the current user's document through this same repo to render their data.

### Dependency Injection

- **get_it**, already wired in `lib/dependencies/dependencies.dart` per this project's existing
  architecture — no new DI mechanism needed. `FirebaseAuth`/`FirebaseFirestore` instances and the
  new `AuthRepo`/`UserRepo` implementations register there via `registerLazySingleton`, consistent
  with [ARCHITECTURE.md](ARCHITECTURE.md)'s "Dependency Injection" section.
