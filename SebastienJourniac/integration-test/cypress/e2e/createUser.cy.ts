describe('create user', () => {
  it('should create user success when submit a valid form', () => {
    cy.visit('http://localhost:4137/#/register')
    cy.get('[placeholder="Your Name"]').type('foo')
    cy.get('[placeholder="Email"]').type('foo@example.com')
    cy.get('[placeholder="Password"]').type('12345678')
    cy.get('[type="submit"]').click()
  })
})
describe('list article from this user', () => {
  it('should list article from this user', () => {
    cy.visit('http://localhost:4137/#/login')
    cy.get('[placeholder="Email"]').type('foo@example.com')
    cy.get('[placeholder="Password"]').type('12345678')
    cy.get('[type="submit"]').click()
    cy.visit('http://localhost:4137/#/')
    cy.get('.nav-link').contains('foo').click()
    cy.get('.article-preview').should('contain', 'No articles are here... yet.')
  })
})

describe('post article', () => {
  it('jump to post detail page when submit create article form', () => {
    cy.visit('http://localhost:4137/#/login')
    cy.get('[placeholder="Email"]').type('foo@example.com')
    cy.get('[placeholder="Password"]').type('12345678')
    cy.get('[type="submit"]').click()
    cy.get('.nav-link').contains('New Post').click()
    cy.get('[placeholder="Article Title"]').type('Title')
    cy.get('[placeholder="What\'s this article about?"]').type('content')
    cy.get('[placeholder="Write your article (in markdown)"]').type('42, j\'en étais sûr !')
    cy.get('[type="submit"]').click()
  })
})
