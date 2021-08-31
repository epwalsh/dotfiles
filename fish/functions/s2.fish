function s2
    curl -X GET "https://api.semanticscholar.org/graph/v1/paper/CorpusID:$argv[1]?fields=url,title,abstract,authors,year,fieldsOfStudy"
end
