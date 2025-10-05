import argparse
import sys
from current_version import VERSION

SUPPORTED_LANGUAGES = { "en": "en_US", "ru" : "ru_RU" }
LANGUAGE = "en_US"
VERSION = "0.0.1" # Add the logic you need to set version

def process_cmdline() -> int:
    parser = argparse.ArgumentParser(
        prog="python-sample-prj", usage=f"%(prog)s [options]\npython-sample-prj {VERSION}"
    )
    parser.add_argument(
        "--list-lang",
        action="store_true",
        help="list supported languages and exit",
    )
    parser.add_argument(
        "--lang",
        type=str,
        default="en_US",
        help="language code to use (default: en_US)",
    )
    args = parser.parse_args()
    if args.list_lang:
        print("Supported languages:")
        for lang in SUPPORTED_LANGUAGES:
            print(f" - {lang}")
        return 0
    if args.lang not in SUPPORTED_LANGUAGES:
        print(
            f"Error: unsupported language '{args.lang}'. Supported languages are: {', '.join(SUPPORTED_LANGUAGES)}",
            file=sys.stderr,
        )
    global LANGUAGE
    LANGUAGE = SUPPORTED_LANGUAGES[args.lang]
    import settings
    from sample.sample import sample_program
    return sample_program()


if __name__ == "__main__":
    sys.exit(process_cmdline())
