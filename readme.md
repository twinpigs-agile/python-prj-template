
When you begin an own Python project, it is very important to start with a good project structure. Below is a material for the tomorrow lesson, a Python project skeleton. I frequently use it for my small to medium projects. It can be customised and already includes many of the things you may need for most projects:

 - build scripts

 - Mypy (static type checking) and Flake8 (linting)

 - code formatting using Black

 - localisation using gettext

 - Jinja2 templates

 - unittest and doctest runs

 - building PyInstaller executables for Windows and Linux

 - GitHub Action with support for checking commits and pull requests (Linux)

 - GitHub Action doing version increments and releases for Windows and Linux (currently it includes only the executables; customise this when building an own project).



It uses Bash scripts even on Windows, so use Git Bash.
