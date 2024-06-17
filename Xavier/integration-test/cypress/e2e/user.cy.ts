import {ROUTES} from "./constant.ts";


describe('user', () => {

  beforeEach(() => {
    cy.intercept('POST', /users$/).as('registerRequest')
    cy.intercept('GET', /user#\/profile\/Bob%20L%C3%A9ponge/).as('articlesList')
  })


  it('Create user', () => {

    // Visit the registration page
    cy.visit(ROUTES.REGISTER)

    // Fill the form
    cy.get('[placeholder="Your Name"]').type('Bob Léponge')
    cy.get('[placeholder="Email"]').type('bob@leponge.fr')
    cy.get('[placeholder="Password"]').type('12345678')

    // Submit the form
    cy.get('[type="submit"]').click()

    // Wait for the registration request to complete
    cy.wait('@registerRequest')
    // Check that the user is redirected to the home page
    cy.url().should('match', /\/#\/$/)
  })

  it('New user articles should be empty', () => {
    // Login
    cy.visit(ROUTES.LOGIN)
    cy.get('[placeholder="Email"]').type('bob@leponge.fr')
    cy.get('[placeholder="Password"]').type('12345678')
    cy.get('[type="submit"]').click()
    cy.wait(50)

    // Visit user profile which contains the articles
    cy.visit('/user#/profile/Bob%20L%C3%A9ponge')
    cy.wait(500)
    // make sure the articles list is empty
    cy.get('[class="article-preview"]').should('contain', ' No articles are here... yet.')

  })

  it('Create article', () => {

    // Login
    cy.visit(ROUTES.LOGIN)
    cy.get('[placeholder="Email"]').type('bob@leponge.fr')
    cy.get('[placeholder="Password"]').type('12345678')
    cy.get('[type="submit"]').click()
    cy.wait(50)

    // Visit the article creation page
    cy.visit('/user#/article/create')
    cy.wait(500)

    // Fill the form
    cy.get('[placeholder="Article Title"]').type('Moules frites')
    cy.get('[placeholder="What\'s this article about?"]').type('Les moules frites, un plat typique du nord de la France')
    cy.get('[placeholder="Write your article (in markdown)"]').type('## Les moules frites\n\nLes moules frites, un plat typique du nord de la France')
    cy.get('[placeholder="Enter tags"]').type('moules, frites')
    cy.get('[type="submit"]').click()

    // Check that the user is redirected to the article page
    cy.url().should('match', /user#\/article\/moules-frites/)

    // Visit user profile which contains the articles
    cy.visit('/user#/profile/Bob%20L%C3%A9ponge')
    cy.wait(500)

    // make sure the articles list contains the new article
    cy.get('div h1').first().should('contain', 'Moules frites')

  })

})
