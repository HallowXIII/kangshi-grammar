# Kangshi Grammar

## General

This repository contains the in-progress grammar of a conlang, the source text
of which is written in markdown. The goal of this repo is to test out
distribution of conlanging work onto multiple platforms using pandoc and the
[pandoc-ling](https://github.com/cysouw/pandoc-ling) lua filter to format
glosses.

## Building

### Output Formats

Currently, the output formats are individual html pages per chapter and an epub
book containing all chapters in order, since those formats are well-supported by
pandoc itself as well as the pandoc-ling filter.

A goal is to be able to compile to mediawiki markup as well as phpbb markup.

### Dependencies

To build the ebook, you need the following software installed:

- [Rake](https://ruby.github.io/rake/)
- [Pandoc](https://pandoc.org/)
- Pandoc-Ling (see above)

Then, from the top-level directory, run either `rake` or `rake html` to compile
individual chapters to html, or `rake epub` to build the book.
