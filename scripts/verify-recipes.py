#!/usr/bin/env python3
"""Check saved-recipe behavior and Swift output against the upstream calculator.

Run from any directory on a Mac with Xcode and Node.js installed. Uses only
standard libraries and the checked-in Lotus reference; no network access.
"""
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "Sources/BlossomRain"
WORK = ROOT / ".build/recipe-checks"
WORK.mkdir(parents=True, exist_ok=True)


def run(*args):
    subprocess.run([str(arg) for arg in args], cwd=ROOT, check=True)


def block(text, marker):
    start = text.index(marker)
    brace = text.index("{", start)
    depth = 0
    for index in range(brace, len(text)):
        if text[index] == "{":
            depth += 1
        elif text[index] == "}":
            depth -= 1
            if depth == 0:
                return text[start:index + 1]
    raise ValueError("Unclosed source block: " + marker)


run("xcrun", "swiftc", "-swift-version", "5",
    SOURCE / "Recipes.swift", SOURCE / "RecipeDetails.swift", SOURCE / "RecipeLibrary.swift",
    ROOT / "Tests/RecipeFeatureChecks.swift", "-o", WORK / "feature-checks")
run(WORK / "feature-checks")

with (WORK / "expected.json").open("w") as output:
    subprocess.run(["node", str(ROOT / "Tests/lotus-reference.cjs"),
                    str(ROOT / "Reference/Lotus/recipes.json"),
                    str(ROOT / "Reference/Lotus/calculate_values.js")],
                   cwd=ROOT, stdout=output, check=True)

# Compile the actual UI drop closures and state so changes to the displayed
# values are checked too, without duplicating their implementation in a test.
state = (SOURCE / "BlossomRainApp.swift").read_text().split("\n@main", 1)[0]
(WORK / "BRState.swift").write_text(state)
view = (SOURCE / "RecipesTab.swift").read_text()
closures = [block(view, "let " + mineral + "DropCount: Int =") + "()"
            for mineral in ("calcium", "magnesium", "potassium", "sodium")]
probe = ("import Foundation\nstruct RecipeCalculatorProbe {\n"
         "var brState = mainBRState\nfunc drops(for recipe: Recipe) -> [Int] {\n" +
         "\n".join(closures) +
         "\nreturn [calciumDropCount, magnesiumDropCount, potassiumDropCount, sodiumDropCount]\n}\n" +
         block(view, "func unitVolumeCalculator(") + "\n}\n")
(WORK / "RecipeCalculatorProbe.swift").write_text(probe)
run("xcrun", "swiftc", "-swift-version", "5", SOURCE / "Recipes.swift",
    SOURCE / "RecipeDetails.swift", SOURCE / "Calculators.swift", SOURCE / "Units.swift",
    WORK / "BRState.swift", WORK / "RecipeCalculatorProbe.swift",
    ROOT / "Tests/RecipeCalculationChecks.swift", "-o", WORK / "calculation-checks")
run(WORK / "calculation-checks", WORK / "expected.json")
