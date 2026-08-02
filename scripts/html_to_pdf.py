#!/usr/bin/env python3
"""
Convert an HTML file (Arabic RTL content, using the skill's template) into a PDF.

Usage:
    python3 html_to_pdf.py input.html output.pdf
"""
import sys
from weasyprint import HTML


def main():
    if len(sys.argv) != 3:
        print("Usage: python3 html_to_pdf.py input.html output.pdf")
        sys.exit(1)

    input_path, output_path = sys.argv[1], sys.argv[2]

    HTML(input_path).write_pdf(output_path)
    print(f"Saved PDF to {output_path}")


if __name__ == "__main__":
    main()
