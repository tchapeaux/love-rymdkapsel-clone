{
    makeWeakTable: (table, key=true, value=true) ->
        meta = getmetatable(table)
        if meta == nil
            meta = {}
        meta.__mode = ""
        if key
            meta.__mode ..= "k"
        if value
            meta.__mode ..= "v"
        setmetatable(table, meta)
}
