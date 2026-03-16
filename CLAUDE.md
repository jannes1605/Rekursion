# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Typst document project for a DHBW (Cooperative State University Baden-Württemberg) thesis about "Rekursion" (Recursion) in the context of modern programming concepts. The project uses the `supercharged-dhbw` package (version 3.4.1) which provides DHBW-specific formatting and structure.

## Building and Compiling

### Compile the document to PDF
```bash
typst compile main.typ
```

### Watch mode (auto-recompile on changes)
```bash
typst watch main.typ
```

### Compile with specific output name
```bash
typst compile main.typ output.pdf
```

## Project Structure

- **main.typ**: Main document entry point. Contains the document configuration (authors, title, company info, etc.) and all content sections.
- **acronyms.typ**: Dictionary of acronyms used throughout the document. Use `#acr("ACRONYM")` in main.typ to reference them.
- **glossary.typ**: Dictionary of glossary terms. Use `#gls("term")` in main.typ to reference them.
- **sources.bib**: BibTeX bibliography file for citations.
- **assets/**: Directory containing images and other assets (e.g., ts.svg).

## Document Configuration

The document is configured via the `#show: supercharged-dhbw.with()` block in main.typ. Key settings:
- `language`: "en" or "de" for English/German
- `at-university`: Set to `true` to hide company information (for university-submitted versions)
- `authors`: Array of author objects with student-id, course, company details
- `acronyms` and `glossary`: Imported dictionaries
- `bibliography`: Linked to sources.bib

## Working with Acronyms and Glossary

### Adding a new acronym
1. Add to the `acronyms` dictionary in acronyms.typ:
   ```typst
   ACRONYM: "Full Expansion",
   ```
2. Reference in main.typ using `#acr("ACRONYM")`, `#acrs("ACRONYM")` (short form), or `#acrlpl("ACRONYM")` (plural)

### Adding a glossary term
1. Add to the `glossary` dictionary in glossary.typ:
   ```typst
   TermName: "Definition of the term.",
   ```
2. Reference in main.typ using `#gls("TermName")`

## Citations

Add entries to sources.bib in BibTeX format, then cite in main.typ using standard Typst citation syntax: `@key` or `@key[page]`.