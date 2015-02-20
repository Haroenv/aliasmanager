aliasdoctor
===

aliasdoctor helps you diagnose your alias usage, and answer the following questions:
- What alias should I add to my dotfiles?
- What alias should I shorten?


Recommended Install
---
```
  gem install aliasmanager
```

For ruby to interact properly with your shell environment, it's easier install aliasmanager through aliases

```
  alias am="alias -L | aliasmanager"
```

Usage
---

`am` For the list of most used commands
`am unaliased` For the list of most used commands that don't have an alias
`am aliased` For the list of most used aliases

