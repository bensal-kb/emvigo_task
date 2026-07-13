# App Requirements

## 1. Overview

The app provides an authentication flow (Login / Signup), a one-time profile-creation step
completed right after signup, and a dummy Home screen reached once the user is authenticated. There
is no backend/API defined yet — Home is a placeholder screen for now.

## 2. Feature List

| Feature | Description |
|---|---|
| Login | Existing user signs in with email/password, or switches to Signup |
| Signup | New user registers with email/password |
| Create Profile | One-time profile setup shown immediately after a successful Signup |
| Home Page | Dummy landing screen for authenticated users, with a Logout option |

## 3. Screen Specifications

### 3.1 Login

| Field | Type | Required |
|---|---|---|
| Email | Text (email) | Yes |
| Password | Text (masked) | Yes |
| Confirm Password | Text (masked) | Yes |

- **Actions:** "Login" button; "Switch to Signup" link/button.
- **Navigation:**
  - Login success → Home Page.
  - "Switch to Signup" → Signup screen.

### 3.2 Signup

| Field | Type | Required |
|---|---|---|
| Email | Text (email) | Yes |
| Password | Text (masked) | Yes |

- **Actions:** "Signup" button.
- **Navigation:**
  - Signup success → Create Profile.

### 3.3 Create Profile

Shown once, immediately after a successful Signup.

| Field | Type | Required |
|---|---|---|
| First Name | Text | Yes |
| Last Name | Text | Yes |
| Date of Birth | Date picker | Yes |
| Gender | Radio (e.g. Male / Female / Other) | Yes |
| Nationality | Dropdown | Yes |
| Languages | Dropdown | Yes |

- **Actions:** "Save" / "Continue" button.
- **Navigation:**
  - Save success → Home Page.

### 3.4 Home Page

- Dummy/placeholder content (no real data or backend).
- **Actions:** "Logout" option.
- **Navigation:**
  - Logout → clears session → Login screen.

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
| Login | Confirm Password | Masked text | Yes | Must match Password |
| Signup | Email | Email | Yes | Valid email format |
| Signup | Password | Masked text | Yes | Minimum length (e.g. 8 chars) |
| Create Profile | First Name | Text | Yes | Non-empty |
| Create Profile | Last Name | Text | Yes | Non-empty |
| Create Profile | Date of Birth | Date | Yes | Valid date, user must be a reasonable age |
| Create Profile | Gender | Radio | Yes | One option selected |
| Create Profile | Nationality | Dropdown | Yes | One option selected |
| Create Profile | Languages | Dropdown | Yes | One option selected |

## 6. Assumptions & Out of Scope

- Login intentionally includes a **Confirm Password** field alongside Password, per the spec — this
  is unusual for a login form (typically only Signup asks users to confirm a new password), but is
  documented as given.
- "Create Profile" is the single post-signup step; there is no separate "Create Password" screen.
- No backend/API is defined — Signup, Login, and Create Profile persistence behavior (local only vs.
  server-backed) is not yet specified. Home Page is explicitly a dummy screen.
- No "Forgot Password" flow is included in this spec.
- Exact option lists for Gender, Nationality, and Languages dropdowns are not specified.

## 7. Mapping to Project Structure

Following this project's [FEATURE_GUIDE.md](FEATURE_GUIDE.md) convention (`lib/features/<name>/`
with `bloc/`, `view/`, `widgets/`):

| Screen(s) | Suggested feature folder |
|---|---|
| Login, Signup | `lib/features/auth/` (already scaffolded) |
| Create Profile | `lib/features/create_profile/` |
| Home Page | `lib/features/home/` |
