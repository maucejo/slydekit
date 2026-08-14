# Publie la documentation vers la branche gh-pages du dépôt.
# Usage :
#   just publish-gh
#   just publish-gh docs main       # source personnalisée, branche personnalisée
publish-gh source="docs/_site" branch="gh-pages":
    SOURCE={{source}} BRANCH={{branch}} ./scripts/publish-docs.sh
