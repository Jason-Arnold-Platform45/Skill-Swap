$issues = @(
  @{
    title = "Issue 5: Create User model with TDD"
    body  = @"
Goal:
Introduce the core User model using MVC and TDD.

Backend:
- User model with email and password_digest
- has_secure_password
- Email uniqueness validation

Tests:
- Valid user
- Missing email
- Duplicate email

Acceptance Criteria:
- rails test passes
- No controller yet
"@
  },

  @{
    title = "Issue 6: Create Skill model (offer and request)"
    body  = @"
Goal:
Model skills that users can offer or request.

Backend:
- Skill model
- Fields: title, description, kind, user_id
- belongs_to user

Rules:
- kind must be offer or request

Tests:
- Validations
- Associations
"@
  },

  @{
    title = "Issue 7: Skills controller read-only API"
    body  = @"
Goal:
Expose public skills via API.

Endpoints:
- GET /skills
- GET /skills/:id

Tests:
- Request specs
- Status codes 200 and 404

Acceptance Criteria:
- JSON only
- No authentication
"@
  },

  @{
    title = "Issue 8: User registration endpoint"
    body  = @"
Goal:
Allow users to register.

Endpoint:
- POST /users

Input:
- email
- password
- password_confirmation

Tests:
- Successful registration
- Invalid params rejected
"@
  },

  @{
    title = "Issue 9: Login and JWT authentication"
    body  = @"
Goal:
Authenticate users and issue JWT tokens.

Endpoint:
- POST /login

Behavior:
- Return JWT on success
- Return 401 on failure

Tests:
- Valid login
- Invalid login
"@
  },

  @{
    title = "Issue 10: Authenticated skill creation"
    body  = @"
Goal:
Only logged-in users can create skills.

Endpoint:
- POST /skills

Rules:
- JWT required
- Skill linked to current user

Tests:
- Authenticated success
- Unauthenticated rejected
"@
  },

  @{
    title = "Issue 11: Skill ownership authorization"
    body  = @"
Goal:
Only skill owners can update or delete skills.

Endpoints:
- PUT /skills/:id
- DELETE /skills/:id

Rules:
- Owner only
- Return 403 if unauthorized

Tests:
- Owner allowed
- Non-owner blocked
"@
  },

  @{
    title = "Issue 12: Match model and business rules"
    body  = @"
Goal:
Represent a skill swap between users.

Backend:
- Match model
- requester_id
- provider_id
- skill_id
- status

Rules:
- Cannot match own skill
- Default status is pending

Tests:
- Business rule enforcement
"@
  },

  @{
    title = "Issue 13: Match creation service object"
    body  = @"
Goal:
Move match logic out of controllers.

Backend:
- Matches::CreateService
- Validates rules
- Creates match

Tests:
- Service-level tests
"@
  },

  @{
    title = "Issue 14: React fetch public skills"
    body  = @"
Goal:
Frontend displays list of skills.

Frontend:
- Fetch GET /skills
- Loading and error states
- Display list

Acceptance Criteria:
- Rails is source of truth
"@
  },

  @{
    title = "Issue 15: React authentication flow"
    body  = @"
Goal:
Allow users to log in.

Frontend:
- Login form
- Store JWT
- Attach token to requests
"@
  },

  @{
    title = "Issue 16: React create skill form"
    body  = @"
Goal:
Authenticated users can create skills.

Frontend:
- Skill form
- POST /skills
- Show validation errors
"@
  },

  @{
    title = "Issue 17: Final cleanup and documentation"
    body  = @"
Goal:
Stabilize and document the application.

Tasks:
- Clean unused code
- Ensure tests pass
- Update README
"@
  }
)

foreach ($issue in $issues) {
  gh issue create `
    --title $issue.title `
    --body $issue.body
}
