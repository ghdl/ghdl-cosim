# -*- coding: utf-8 -*-

import sys, re
from os.path import abspath
from pathlib import Path
from json import dump, loads

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
sys.path.insert(0, abspath('.'))

# -- General configuration ------------------------------------------------

# If your documentation needs a minimal Sphinx version, state it here.
needs_sphinx = '1.5'

extensions = [
    # Standard Sphinx extensions
    'recommonmark',
    'sphinx.ext.extlinks',
    'sphinx.ext.intersphinx',
    'sphinx.ext.todo',
    'sphinx.ext.graphviz',
    'sphinx.ext.mathjax',
    'sphinx.ext.ifconfig',
    'sphinx.ext.viewcode',
]

templates_path = ['_templates']

# The suffix(es) of source filenames.
source_suffix = {
    '.rst': 'restructuredtext',
    # '.txt': 'markdown',
    '.md': 'markdown',
}

# The master toctree document.
master_doc = 'index'

# General information about the project.
project = u'GHDL-cosim'
copyright = u'2020, Tristan Gingold and contributors'
author = u'Tristan Gingold and contributors'

# The version info for the project you're documenting, acts as replacement for
# |version| and |release|, also used in various other places throughout the
# built documents.

version = "latest"
release = version  # The full version, including alpha/beta/rc tags.

# The language for content autogenerated by Sphinx. Refer to documentation
# for a list of supported languages.
# This is also used if you do content translation via gettext catalogs.
# Usually you set "language" from the command line for these cases.
language = None

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
exclude_patterns = []

# If true, `todo` and `todoList` produce output, else they produce nothing.
todo_include_todos = True
todo_link_only = True

# reST settings
prologPath = "prolog.inc"
try:
    with open(prologPath, "r") as prologFile:
        rst_prolog = prologFile.read()
except Exception as ex:
    print("[ERROR:] While reading '{0!s}'.".format(prologPath))
    print(ex)
    rst_prolog = ""

# -- Options for HTML output ----------------------------------------------

html_logo = "_static/logow.svg"

html_theme_options = {
    'logo_only': True,
    'home_breadcrumbs': False,
    'vcs_pageview_mode': 'blob',
}

html_context = {}
ctx = Path(__file__).resolve().parent / 'context.json'
if ctx.is_file():
    html_context.update(loads(ctx.open('r').read()))

html_theme_path = ["."]
html_theme = "_theme"

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

# Output file base name for HTML help builder.
htmlhelp_basename = 'GHDLcosimdoc'

# -- Options for LaTeX output ---------------------------------------------

latex_elements = {
    'papersize': 'a4paper',
}

# Grouping the document tree into LaTeX files. List of tuples
# (source start file, target name, title, author, documentclass [howto, manual, or own class]).
latex_documents = [
    (master_doc, 'GHDLcosim.tex', u'GHDL Cosimulation Documentation', author, 'manual'),
]

# -- Options for manual page output ---------------------------------------

# One entry per manual page. List of tuples
# (source start file, name, description, authors, manual section).
man_pages = [
    (master_doc, 'ghdl-cosim', u'GHDL Cosimulation Documentation', [author], 1)
]

# -- Options for Texinfo output -------------------------------------------

# Grouping the document tree into Texinfo files. List of tuples
# (source start file, target name, title, author, dir menu entry, description, category)
texinfo_documents = [
  (master_doc, 'GHDL-cosim', u'GHDL Cosimulation Documentation', author, 'GHDL', 'VHDL simulator.', 'Miscellaneous'),
]

# -- Sphinx.Ext.InterSphinx -----------------------------------------------

intersphinx_mapping = {
   'python': ('https://docs.python.org/3.8/', None),
   'ghdl': ('https://ghdl.github.io/ghdl', None),
   'vunit': ('https://vunit.github.io', None),
   'matplotlib': ('https://matplotlib.org/', None)
}

# -- Sphinx.Ext.ExtLinks --------------------------------------------------
extlinks = {
   'wikipedia':  ('https://en.wikipedia.org/wiki/%s', None),
   'ghdlsharp':  ('https://github.com/ghdl/ghdl/issues/%s', 'ghdl#'),
   'ghdlissue':  ('https://github.com/ghdl/ghdl/issues/%s', 'issue #'),
   'ghdlpull':   ('https://github.com/ghdl/ghdl/pull/%s', 'pull request #'),
   'ghdlsrc':    ('https://github.com/ghdl/ghdl/blob/master/src/%s', None),
   'cosimsharp': ('https://github.com/ghdl/ghdl-cosim/issues/%s', 'ghdl-cosim#'),
   'cosimtree':  ('https://github.com/ghdl/ghdl-cosim/blob/master/%s', None),
}
