package main

import (
	"github.com/aaron-imbrock/snippetbox/internal/models"
)

type templateData struct {
	Snippet  models.Snippet
	Snippets []models.Snippet
}
