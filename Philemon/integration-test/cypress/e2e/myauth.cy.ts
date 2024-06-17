import {ROUTES} from "./constant.ts";

const name = 'CrazyTester';
const mail = name + '@example.com';

const title ='Title test';
const about ='About testing';
const content ='Write your testing text';
const tag = 'Testing tag';


describe('create user', () => {
  it('should complete the registration form', () => {


    cy.visit(ROUTES.REGISTER)
    cy.get('[placeholder="Your Name"]').type(name)
    cy.get('[placeholder="Email"]').type(mail)
    cy.get('[placeholder="Password"]').type('12345678')
    cy.get('[type="submit"]').click()

  })

})

describe('check article', () => {
  it("should check if the user has an article", () => {

    cy.visit(ROUTES.LOGIN)
    cy.get('[placeholder="Email"]').type(mail)
    cy.get('[placeholder="Password"]').type('12345678')
    cy.get('[type="submit"]').click()
    cy.wait(500)
    cy.visit(`http://localhost:4137/#/profile/${name}`)
    cy.wait(500)

  });
})

describe('create article', () => {
  it('should post a new article', () => {

    cy.visit(ROUTES.LOGIN)
    cy.get('[placeholder="Email"]').type(mail)
    cy.get('[placeholder="Password"]').type('12345678')
    cy.get('[type="submit"]').click()
    cy.wait(500)


    cy.get('[href="#/article/create"]').click()
    cy.get('[placeholder="Article Title"]').type(title)
    cy.get('[placeholder="What\'s this article about?"]').type(about)
    cy.get('[placeholder="Write your article (in markdown)"]').type(content)
    cy.get('[placeholder="Enter tags"]').type(tag)
    cy.get('[type="submit"]').click()
    cy.wait(500)
    cy.visit(`http://localhost:4137/#/profile/${name}`)
    cy.wait(500)




  });
})
