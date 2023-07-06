


client_url <- 'https://api-delphi.kt.ktzh.ch/graphql/'
auth_query <- 'mutation {
  jwtAuthentication(password: "HMq{J_25f9my#8", username: "DelphiApiRead") {
    firstName
    tokenValidTo
    id
    lastName
    password
    token
  }
}'

get_authentifaction_token <- function(client_url, auth_query){
  
  client <- ghql::GraphqlClient$new(url = client_url)
  
  qry <- ghql::Query$new()
  
  qry$query("authenticate", auth_query)
  
  response <- client$exec(qry$queries$authenticate)
  
  response <- jsonlite::fromJSON(response, flatten = T)
  
  token <- response$data$jwtAuthentication$token
  
}
