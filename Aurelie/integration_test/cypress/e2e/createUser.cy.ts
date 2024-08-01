describe('createUser', () => {
    // Create user
    // it('user creation', () => {
    //   cy.visit(' http://localhost:4137/#/')
    //   cy.get(':nth-child(3) > .nav-link').click()
    //   cy.get(':nth-child(1) > .form-control').type('toti')
    //   cy.get(':nth-child(2) > .form-control').type('toti@mail.com')
    //   cy.get(':nth-child(3) > .form-control').type('blabla')
    //   cy.get('.btn').click()
    // })

    // Verify the new user has no articles
    it ('verifier si article est null', ()=>{
        cy.visit(' http://localhost:4137/#/')
        cy.get(':nth-child(2) > .nav-link').click()
        cy.get('[aria-required="true"] > .form-control').type('toti@mail.com')
        cy.get(':nth-child(2) > .form-control').type('blabla')
        cy.get('.btn').click()
        cy.get(':nth-child(4) > .nav-link').click()
        cy.get(':nth-child(1) > .active').click()
        cy.get('.article-preview').should('contain', 'No articles are here... yet.')
    })
})
