import { ROUTES } from './constant'

describe('createUser', () => {
  it('should create a new user', () => {
    cy.visit(`http://localhost:4137${ROUTES.REGISTER}`)
    cy.get('[placeholder="Your Name"]').type('hugotest')
    cy.get('[placeholder="Email"]').type('hugotest@gmail.com')
    cy.get('[placeholder="Password"]').type('hugopassword')
    cy.get('[type="submit"]').click()
  })
})

describe('has no article', () => {
  it('verify the new user has no articles', () => {
    cy.visit(`http://localhost:4137${ROUTES.LOGIN}`)
    cy.get('[type="email"]').type('hugotest@gmail.com')
    cy.get('[type="password"]').type('hugopassword')
    cy.get('[type="submit"]').click()
    cy.visit(`http://localhost:4137${ROUTES.HOME}`)
    cy.wait(500)
    cy.get('.navbar').contains('hugotest').should('be.visible')
    cy.get('.navbar').contains('hugotest').click()
    cy.contains('No articles are here... yet.').should('be.visible')
  })
})

describe('post', () => {
  it('should create a new post', () => {
    cy.visit(`http://localhost:4137${ROUTES.LOGIN}`)
    cy.get('[type="email"]').type('hugotest@gmail.com')
    cy.get('[type="password"]').type('hugopassword')
    cy.get('[type="submit"]').click()
    cy.get('[href="#/article/create"]').click()
    cy.get('[placeholder="Article Title"]').type('Main heimerdinger')
    cy.get('[placeholder="What\'s this article about?"]').type('Heimerdinger > Darius')
    cy.get('[placeholder="Write your article (in markdown)"]').type('Un champion très skiller')
    cy.get('[placeholder="Enter tags"]').type('Master')
    cy.get('[type="submit"]').click()
  })
})

describe('have article', () => {
  it('verify the new user has articles', () => {
    cy.visit(`http://localhost:4137${ROUTES.LOGIN}`)
    cy.get('[type="email"]').type('hugotest@gmail.com')
    cy.get('[type="password"]').type('hugopassword')
    cy.get('[type="submit"]').click()
    cy.visit(`http://localhost:4137${ROUTES.HOME}`)
    cy.wait(500)
    cy.get('.navbar').contains('hugotest').should('be.visible')
    cy.get('.navbar').contains('hugotest').click()
    cy.contains('Main heimerdinger').should('be.visible')
  })
})
