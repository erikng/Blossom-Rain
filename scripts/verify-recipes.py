#!/usr/bin/env python3
"""Check saved-recipe behavior and Swift output against the upstream calculator.

Run from any directory on a Mac with Xcode and Node.js installed. Uses only
standard libraries and the checked-in Lotus reference; no network access.
"""
from pathlib import Path
import platform
import subprocess

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "Sources/BlossomRain"
WORK = ROOT / ".build/recipe-checks"
WORK.mkdir(parents=True, exist_ok=True)


def run(*args):
    subprocess.run([str(arg) for arg in args], cwd=ROOT, check=True)


SWIFT = ("xcrun", "swiftc", "-swift-version", "6", "-warnings-as-errors",
         "-target", f"{platform.machine()}-apple-macos14.0")
MODELS = (SOURCE / "Recipes.swift", SOURCE / "RecipeDetails.swift",
          SOURCE / "Calculators.swift", SOURCE / "Units.swift")


run(*SWIFT,
    SOURCE / "Recipes.swift", SOURCE / "RecipeDetails.swift", SOURCE / "RecipeLibrary.swift",
    ROOT / "Tests/RecipeFeatureChecks.swift", "-o", WORK / "feature-checks")
run(WORK / "feature-checks")

run(*SWIFT, *MODELS, SOURCE / "BRState.swift",
    ROOT / "Tests/BrewStateChecks.swift", "-o", WORK / "brew-state-checks")
run(WORK / "brew-state-checks")

with (WORK / "expected.json").open("w") as output:
    subprocess.run(["node", str(ROOT / "Tests/lotus-reference.cjs"),
                    str(ROOT / "Reference/Lotus/recipes.json"),
                    str(ROOT / "Reference/Lotus/calculate_values.js")],
                   cwd=ROOT, stdout=output, check=True)

# Compile the same production calculator called by RecipeDropsSection.
run(*SWIFT, *MODELS,
    ROOT / "Tests/RecipeCalculationChecks.swift", "-o", WORK / "calculation-checks")
run(WORK / "calculation-checks", WORK / "expected.json")
