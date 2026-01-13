Write-Host "Creating milestones..."

$repo = gh repo view --json nameWithOwner -q .nameWithOwner

$milestones = @(
  "Sprint 1 - Setup and Core Domain MVC",
  "Sprint 2 - Authentication and Authorization",
  "Sprint 3 - Matching System Business Logic",
  "Sprint 4 - UX Testing and Final Polish"
)

foreach ($m in $milestones) {
  gh api repos/$repo/milestones -f title="$m" 2>$null
}

function New-Issue {
  param ($title, $body, $milestoneTitle)
  gh issue create `
    --title "$title" `
    --body "$body" `
    --milestone "$milestoneTitle"
}

Write-Host "Creating issues..."

# ======================
# Sprint 1
# ======================

New-Issue "Initialize monorepo structure" `
"Create frontend (React) and backend (Rails API) folders." `
"Sprint 1 - Setup and Core Domain MVC"

New-Issue "Setup Rails API with PostgreSQL" `
"Rails API setup with PostgreSQL. Smoke test." `
"Sprint 1 - Setup and Core Domain MVC"

New-Issue "Setup React frontend view layer" `
"React app setup. View layer only." `
"Sprint 1 - Setup and Core Domain MVC"

New-Issue "Configure CORS" `
"Allow frontend to access backend API." `
"Sprint 1 - Setup and Core Domain MVC"

New-Issue "User model validations TDD" `
"Model tests first. Validations and associations." `
"Sprint 1 - Setup and Core Domain MVC"

New-Issue "Skill model offer request TDD" `
"Skill belongs to user. Offer or request." `
"Sprint 1 - Setup and Core Domain MVC"

# ======================
# Sprint 2
# ======================

New-Issue "User authentication model TDD" `
"Secure password handling." `
"Sprint 2 - Authentication and Authorization"

New-Issue "JWT login endpoint" `
"Generate JWT token on login." `
"Sprint 2 - Authentication and Authorization"

New-Issue "Protect endpoints with JWT" `
"Require authentication for protected routes." `
"Sprint 2 - Authentication and Authorization"

# ======================
# Sprint 3
# ======================

New-Issue "Match model business rules TDD" `
"Offer to request matching only." `
"Sprint 3 - Matching System Business Logic"

New-Issue "Match service objects" `
"Encapsulate matching workflows." `
"Sprint 3 - Matching System Business Logic"

# ======================
# Sprint 4
# ======================

New-Issue "React UX improvements" `
"Loading states and error handling." `
"Sprint 4 - UX Testing and Final Polish"

New-Issue "Final integration tests" `
"End-to-end happy path." `
"Sprint 4 - UX Testing and Final Polish"

Write-Host "All milestones and issues created successfully!"
