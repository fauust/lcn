describe('create user', () => {
  beforeEach(() => {
    cy.request({
      method: 'DELETE',
      url: 'http://localhost:4137/api/users/foo@example.com', // Remplacez par l'URL de votre API pour supprimer un utilisateur
      failOnStatusCode: false, // Ne pas échouer si l'utilisateur n'existe pas
    })
  })
  it('should create user success when submit a valid form', () => {
    cy.visit('http://localhost:4137/#/register')
    cy.get('[placeholder="Your Name"]').type('foo')
    cy.get('[placeholder="Email"]').type('foo@example.com')
    cy.get('[placeholder="Password"]').type('12345678')

    cy.get('[type="submit"]').click()
  })
})
