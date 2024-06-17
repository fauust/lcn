import { ROUTES } from './constant';

describe('Create User', () => {
  const toto = '7k4f8';
  const mel = 'hfh@example.com';

  it('should create a new user, post an article, and verify article in user profile', () => {
    cy.visit(ROUTES.REGISTER);
    cy.get('[aria-label="Username"]', { timeout: 10000 }).should('be.visible');
    cy.get('[aria-label="Username"]').type(toto);
    cy.get('[aria-label="Email"]').type(mel);
    cy.get('[aria-label="Password"]').type('password123');
    cy.get('form').submit();

    cy.visit('#/profile/' + toto);
    cy.get('.article-preview').should('not.exist');

    cy.get('[href="#/article/create"]').click()
    cy.get('[aria-label="Title"]').type('New Article Title');
    cy.get('[aria-label="Description"]').type('Content of the article');
    cy.get('[aria-label="Body"]').type('## Test article content');
    cy.get('[aria-label="Tags"]').type('cypress');
    cy.get ('[class="btn btn-lg pull-xs-right btn-primary"]').click();

    cy.visit('#/profile/' + toto);
    cy.get('.article-preview').should('exist');


  });
});
