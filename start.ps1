$ErrorActionPreference = "Stop"

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw "Docker is not installed or is not on PATH. Install Docker Desktop, restart PowerShell, and run this script again."
}

if (-not (Test-Path -LiteralPath ".env")) {
    Copy-Item -LiteralPath ".env.example" -Destination ".env"
}

docker compose up -d postgres

Write-Host "Waiting for PostgreSQL..."
for ($attempt = 1; $attempt -le 30; $attempt++) {
    docker compose exec -T postgres pg_isready -U postgres -d hummingflow *> $null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "PostgreSQL is ready."
        python -m uvicorn app.main:app --reload
        exit $LASTEXITCODE
    }
    Start-Sleep -Seconds 2
}

throw "PostgreSQL did not become ready within 60 seconds. Run 'docker compose logs postgres' for details."

