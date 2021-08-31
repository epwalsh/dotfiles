function s2fd
    curl -X GET "https://api.semanticscholar.org/graph/v1/paper/search?fields=url,title,abstract,authors,year,fieldsOfStudy&limit=1&query=$argv[1]" | jq '.data[0]'
end
