[X] Build an MVC Sinatra Application.
      Completion Explanation:
        - M: User, Person, Reading, Comment, Comment_Reading
        - V: Users, People, Readings, Comments
        - C: UsersController, PeopleController, ReadingsController,
              CommentsController


[X] Use ActiveRecord with Sinatra.
      Completion Explanation:
        Relationships:
          - Person has many users, readings and comments through readings
          - User belongs to person
          - Reading belongs to person and has many comment_readings which
              allows it to have many comments
          - Comment has many comment_readings which allows it to have many
              readings and people through readings
          - CommentReading belongs to comment and reading


[X] Use Multiple Models.
      Completion Explanation:
      - Models: User, Person, Reading, Comment, Comment_Reading

[X] Use at least one has_many relationship
      Completion Explanation:
      - Used 'has_many', 'belongs_to' & 'has_many through'

[X] Must have user accounts. The user that created a given piece of content
    should be the only person who can modify that content
      Completion Explanation:
      - My app is a website that allows the users to keep track of their blood
          pressure (bp). A user has to create an account to use the site. I
          use the helper method 'current_user' to ensure that only the creator
          of a profile or reading can view/edit/delete info.


[X] You should validate user input to ensure that bad data isn't created
      Completion Explanation:
      - Upon signup and logging in my app verifies that all field are filled in.
          When a user is returning my app authenticates the user and their
          password before they can enter my website.
