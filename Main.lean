import VersoSlides
import Slides

open VersoSlides

/-- Reveal.js settings matching `../understanding-your-agent/defaults.yaml` and pandoc's
revealjs template. `custom.css` is read at run time, so edits need no rebuild. -/
def main : IO UInt32 := do
  let css ← IO.FS.readFile "custom.css"
  slidesMain
    (config := {
      theme := "white"
      transition := "none"
      navigationMode := "linear"
      extraCss := #[{ filename := "custom.css", contents := ⟨css⟩ }] })
    (doc := %doc Slides)
