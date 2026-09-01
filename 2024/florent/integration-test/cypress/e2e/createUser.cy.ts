import { ROUTES } from './constant'

describe('Create user', () => {
  it('Visits and fill register', () => {
    cy.visit('http://127.0.0.1:4137/#/register')

    cy.get('[placeholder="Your Name"]').type('toto')
    cy.get('[placeholder="Email"]').type('toto@example.com')
    cy.get('[placeholder="Password"]').type('1234')

    cy.get('[type="submit"]').click()
  })
})

describe('User has no article', () => {
  it('Isn\'t aricles', () => {
    cy.visit('http://127.0.0.1:4137/#/login')
    cy.get('[placeholder="Email"]').type('toto@example.com')
    cy.get('[placeholder="Password"]').type('1234')

    cy.get('[type="submit"]').click()

    cy.get('[aria-label="toto"]').click()

    cy.get('a').contains('My articles').click()
  })
})

describe('Create article', () => {
  it('New aricle', () => {
    cy.visit('http://127.0.0.1:4137/#/login')
    cy.get('[placeholder="Email"]').type('toto@example.com')
    cy.get('[placeholder="Password"]').type('1234')

    cy.get('[type="submit"]').click()

    cy.get('[aria-label="New Post"]').click()

    cy.get('[placeholder="Article Title"]').type('New title')
    cy.get('[placeholder="What\'s this article about?"]').type('La dépression pour les nuls')
    cy.get('[placeholder="Write your article (in markdown)"]').type('La dépression est un trouble mental...')
    // cy.get('[placeholder="Enter tags"]').type('Psykokwak')

    cy.get('[type="submit"]').click()
  })
})

describe('Get article exists', () => {
  it('show aricle', () => {
    cy.visit('http://127.0.0.1:4137/#/login')
    cy.get('[placeholder="Email"]').type('toto@example.com')
    cy.get('[placeholder="Password"]').type('1234')

    cy.get('[type="submit"]').click()

    cy.get('[aria-label="toto"]').click()
    cy.get('a').contains('My articles').click()
  })
})
