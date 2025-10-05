"""
Import this file ONLY after setting the LANGUAGE variable in the main module!
You should assign a locale name to it ("en_US", "ru_RU", etc.)
If you initialise the locale somewhere else, still do it before the first
import of settings and use something like:
setattr(sys.modules["__main__"], "LANGUAGE", "en_US")
"""

import os.path
import gettext
import sys

SRC_DIR = os.path.dirname(os.path.abspath(__file__))
SRC_DIR = getattr(sys, "_MEIPASS", SRC_DIR)  # PyInstaller support

LOCALES_DIR = os.path.join(SRC_DIR, "locales")
TEMPLATE_DIR = os.path.join(SRC_DIR, "templates")

if SRC_DIR not in sys.path:  # pragma: no cover
    sys.path.append(SRC_DIR)

LANGUAGE = getattr(sys.modules["__main__"], "LANGUAGE", "en_US")

TRANSLATION = gettext.translation(
    "messages", localedir=LOCALES_DIR, languages=[LANGUAGE]
)
_ = TRANSLATION.gettext
