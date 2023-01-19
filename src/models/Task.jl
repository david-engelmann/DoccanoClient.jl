Base.@kwdef struct TaskStatus
    ready::Bool
    result::Union{Any, Nothing} = nothing
    error::Union{Any, Nothing} = nothing
end
Base.@kwdef struct Task
    DOCUMENT_CLASSIFICATION::String = "DocumentClassification"
    SEQUENCE_LABELING::String = "SequenceLabeling"
    SEQ2SEQ::String = "Seq2seq"
    SPEECH2TEXT::String = "Speech2text"
    IMAGE_CLASSIFICATION::String = "ImageClassification"
    BOUNDING_BOX::String = "BoundingBox"
    SEGMENTATION::String = "Segmentation"
    IMAGE_CAPTIONING::String = "ImageCaptioning"
    INTENT_DETECTION_AND_SLOT_FILLING::String = "IntentDetectionAndSlotFilling"
    RELATION_EXTRACTION::String = "RelationExtraction"
end
