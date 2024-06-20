//Création utilisateur Eddy
describe('User creation', () => {
  it('Should create Eddy', () => {
    cy.visit('http://localhost:4137/#/')
    // Clique sur le bouton sign in
    cy.contains('Sign in').click()
    // Ecrit eddy dans l'input qui a pour placeholder Your Name
    //cy.get('input[placeholder="Your Name"]').type('Eddy')
    // Ecrit l'email dans l'input qui a pour placeholder Email
    cy.get('input[placeholder="Email"]').type('eddy@gmail.com')
    //Ecrit le mot de passe dans l'input qui a pour placeholder Password
    cy.get('input[placeholder="Password"]').type('Password')
    // Clique sur le bouton Sign up
    cy.get('[type="submit"]').click()
    //Go on account menu (click pon your name)
    cy.get('.navbar').contains('Eddy').click()
    //assert No articles
    cy.get('.container')
      .should('contain', 'No articles are here... yet.')
    //Create articles
    cy.get('.navbar').contains('New Post').click()
    //Fill the input
    cy.get('[placeholder="Article Title"]').type('Pourquoi les entreprises n\'aiment pas les alternants DEVOPS ?')
    cy.get("[placeholder=\"What's this article about?\"]").type("Hugo ")
    cy.get('[placeholder="Write your article (in markdown)"]').type('Axel')
    cy.get('[placeholder="Enter tags"]').type('Eddy')
    // Submit
    cy.get('[type="submit"]').click()
    // Go on the user's account page
    cy.get('.navbar').contains('Eddy').click()
    // Verify if the article's here
    cy.get('.article-preview')
      .should('contain', 'Pourquoi les entreprises n\'aiment pas les alternants DEVOPS ?')


  })
})
