defmodule B10g.Names do
  @adjectives [
    "autumn", "hidden", "bitter", "misty", "silent", "empty", "dry", "dark",
    "summer", "icy", "delicate", "quiet", "white", "cool", "spring", "winter",
    "patient", "twilight", "dawn", "crimson", "wispy", "weathered", "blue",
    "billowing", "broken", "cold", "damp", "falling", "frosty", "green",
    "long", "late", "bold", "little", "morning", "muddy",
    "red", "rough", "still", "small", "sparkling", "shy",
    "wandering", "withered", "wild", "black", "young", "holy", "solitary",
    "fragrant", "aged", "snowy", "proud", "floral", "restless",
    "polished", "purple", "lively", "nameless"
   ]

  @nouns [
      "waterfall", "river", "breeze", "moon", "rain", "wind", "sea", "morning",
      "snow", "lake", "sunset", "pine", "shadow", "leaf", "dawn", "glitter",
      "forest", "hill", "cloud", "meadow", "sun", "glade", "bird", "brook",
      "butterfly", "bush", "dew", "dust", "field", "fire", "flower", "firefly",
      "feather", "grass", "haze", "mountain", "night", "pond", "darkness",
      "snowflake", "silence", "sound", "sky", "shape", "surf", "thunder",
      "violet", "water", "wildflower", "wave", "water", "resonance", "sun",
      "wood", "dream", "cherry", "tree", "fog", "frost", "voice", "paper",
      "frog", "smoke", "star"
     ]

  def random_name do
    "#{Enum.random(@adjectives)}-#{Enum.random(@nouns)}-#{:rand.uniform(9999)}"
  end
end