# Gets all info when the argument is an object
function allinfo(obj_)
   obj_type = typeof(obj_)
   display(fieldnames(obj_type))
   methodswith(obj_type)
end

# Gets all info when argument is a Type
function allinfo(type_::Type)
   display(fieldnames(type_))
   methodswith(type_)
end

# Gets all info when the argument is a parametric type of Type
function allinfo(type_::Type{T}) where T <: Type
   methodswith(type_)
end

