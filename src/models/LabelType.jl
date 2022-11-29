
VALID_PREFIX_KEY = ["ctrl", "shift", "ctrl shift"]
VALID_SUFFIX_KEY = ["0",
                    "1",
                    "2",
                    "3",
                    "4",
                    "5",
                    "6",
                    "7",
                    "8",
                    "9",
                    "a",
                    "b",
                    "c",
                    "d",
                    "e",
                    "f",
                    "g",
                    "h",
                    "i",
                    "j",
                    "k",
                    "l",
                    "m",
                    "n",
                    "o",
                    "p",
                    "q",
                    "r",
                    "s",
                    "t",
                    "u",
                    "v",
                    "w",
                    "x",
                    "y",
                    "z"]

Base.@kwdef struct TextConstraint
    min_length::Integer = 1
    max_length::Integer = 100
    strip_whitespace::Bool = true
end

Base.@kwdef struct ColorConstraint
    regex_validation::String = r"#[a-fA-F0-9]{6}"
end

struct LabelType
    id::Union{Integer, nothing}
    text::String
    prefix_key::Union{String, nothing}
    suffix_key::Union{String, nothing}
    background_color::String
    text_color::String
end

struct CategoryType <: LabelType
end

struct SpanType <: LabelType
end

struct RelationType <: LabelType
end


