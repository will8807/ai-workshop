# Game Logic Backend Core

This component implements the core game logic engine and FastAPI endpoints for the Rock-Paper-Scissors-Lizard-Spock game.

## Tech Stack
- **Runtime & Package Manager**: Python >= 3.11 with `uv`
- **Web Framework**: FastAPI
- **Formatting & Linting**: Ruff
- **Static Type Checking**: Pyright
- **Test Framework**: Pytest

## Development Commands

```bash
# Initialize and sync virtualenv
uv sync

# Run tests
uv run pytest

# Format and lint
uv run ruff format
uv run ruff check --fix

# Type check
uv run pyright
```
