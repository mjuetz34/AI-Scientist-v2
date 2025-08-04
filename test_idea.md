# Title: IDEEN-DISS – Optimierter Dissertationstest für das AI Scientist System

## Keywords
dissertation, CD44, HNSCC, markdown, APA 7th, GPT, Gemini, PubMed, optimization

## TL;DR
Dieses Markdown-Dokument dient als zentraler Testfall für die Validierung des AI Scientist Systems. Es orchestriert die automatische Rekonstruktion, Optimierung und APA-konforme Formatierung einer medizinischen Dissertation über CD44 als Tumorstammzellmarker bei HNSCC unter Verwendung von GPT- und Gemini-Agenten.

## Abstract
Diese Datei stellt eine prototypische Konfigurations- und Steuerstruktur zur Verfügung, um eine bestehende medizinische Dissertation im Markdown-Format automatisiert zu rekonstruieren, sprachlich zu überarbeiten, mit Literaturquellen aus PubMed zu verknüpfen und schließlich in ein abgabefähiges APA-7-konformes DOCX-Dokument zu überführen. Ziel ist die Integration in ein KI-gestütztes Dissertations-Framework auf Basis von GPT-4, Gemini Pro und PubMed Citation Retrieval.

## Chapter Overview

| Kapitel                  | Status     | Ziel                                   | Modell       |
|--------------------------|------------|----------------------------------------|--------------|
| 01_hintergrund.md        | ✅ fertig   | Stil, APA 7, Strukturprüfung           | GPT-4        |
| 02_fragestellung.md      | ⏳ offen    | Argumentlogik, Hypothesenschärfung     | Gemini Pro   |
| 03_material_methoden.md  | 🟡 in Arbeit| Methodenkritik, PubMed-Verknüpfung     | GPT-4        |
| 04_ergebnisse.md         | 🔴 offen    | Darstellung, Tabellenlogik, Stil       | Gemini Pro   |
| 05_diskussion.md         | 🔴 offen    | Forschungskontext, Schlussfolgerungen  | GPT-4        |

## Citation & Referencing

- Zitierstil: APA 7th Edition
- Automatischer Lookup: PubMed API (PMID, DOI)
- Integration: JavaScript-Modul `pubmed-citation.js`

## Configuration

```yaml
input_format: markdown
output_format: docx
citation_style: APA-7
language: de
llm_models:
  - openai/gpt-4
  - anthropic/gemini-pro
tools:
  - pubmed-citation.js
  - optimizer.js
track_changes: truem

