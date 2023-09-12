class QueryScript {
  //Get All Data
  String allQuery() {
    return """
        query {
        users{
          name
          id
          profession
          age
          posts{
              id
              comment
              userId
          }
          hobbies{
            id
            title
            description
            userId
          }
        }
        } 
     """;
  }

  //Mutation - Create User
  String insertUser() {
    return """ 
   mutation createUser(\$name: String!, \$age: Int!, \$profession: String!){
     createUser(name: \$name, age: \$age, profession: \$profession) {
         id
         name
     }
}
  """;
  }

  //Mutation - Create Post
  String insertPost() {
    return """
    mutation createPost(\$comment: String!, \$userId: String!) {
      createPost(comment: \$comment, userId: \$userId){
         id
         comment
      }   
    }
    """;
  }

  //Mutation - Create Hobby
  String insertHobby() {
    return """
  mutation createHobby(\$title: String!, \$description: String!, \$userId: String!){
      createHobby(title: \$title, description: \$description, userId: \$userId){
         id
         title
      }
  }
    """;
  }

  //Mutation - Update User
  String updateUser() {
    return """
    mutation UpdateUser(\$id: String!, \$name: String!, \$profession: String!, \$age: Int!) {
      UpdateUser(id: \$id, name: \$name, profession: \$profession, age: \$age){
         
         name
      }   
    }
    """;
  }

  //Mutation - Remove User
  String removeUser() {
    return """
  mutation RemoveUser(\$id: String!) {
    RemoveUser(id: \$id){
        name
    }   
  }
  """;
  }

  //Mutation - Remove Post
  String removePosts() {
    return """ 
    mutation RemovePosts(\$ids: [String]) {
      RemovePosts(ids: \$ids){
         
      }   
    }
    """;
  }

  //Mutation - Remove Hobby
  String removeHobbies() {
    return """
    mutation RemoveHobbies(\$ids: [String]) {
      RemoveHobbies(ids: \$ids){
       
      }   
    }
     """;
  }
}
