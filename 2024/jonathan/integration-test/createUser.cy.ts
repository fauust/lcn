import { ROUTES } from './constant'


describe('User Registration', () => {
  it('should register a new user successfully', () => {
    //Visit the register page
    cy.visit(ROUTES.REGISTER)

    // Fill the sign in form
    cy.get('input[aria-label="Username"]').type('testuser')
    cy.get('input[aria-label="Email"]').type('testuser@example.com')
    cy.get('input[aria-label="Password"]').type('password123')

    // Submit the form
    cy.get('[type="submit"]').click()

    // Check the url
    cy.url().should('match', /\/#\/$/)

    // Check that the user is reachable
    cy.get('a.nav-link')
      .should('contain', 'testuser')

    // Reach the testuser page
    cy.get('a.nav-link[href="#/profile/testuser"]')
      .click()

    // Check that he didn't send any post
    cy.get('div.article-preview')
      .should('contain', 'No articles')

    // Reach the article creation page
    cy.get('a.nav-link[href="#/article/create"]')
      .click()

    // Insert an article
    cy.get('input[aria-label="Title"]').type('La galère, bro...')
    cy.get('input[aria-label="Description"]').type('Comment faire des test d integration')
    cy.get('textarea[aria-label="Body"]').type('Alors, t es près??...')
    cy.get('input[aria-label="Tags"]').type('lol')
    cy.get('[type="submit"]').click()

    // Check that the user page contains the article
    cy.get('a.nav-link[href="#/profile/testuser"]')
      .click()

    cy.get('h1')
      .should('contain', 'La galère, bro...')
  })
})
