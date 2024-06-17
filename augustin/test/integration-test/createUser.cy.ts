import { ROUTES } from "./constant";
let name = "bob" + Date.now();
describe("article", () => {
  describe("post article", () => {
    it("should create new user", () => {
      cy.visit(ROUTES.REGISTER);
      cy.get('[type="text"]').type(name);
      cy.get('[type="email"]').type(name + "@example.com");
      cy.get('[type="password"]').type(name);
      cy.get('[type="submit"]').contains("Sign up").click();
      cy.wait(1000);
      cy.get('[aria-label="' + name + '"]').should("contain", name);
    });
    it("should not have articles", () => {
      cy.visit(ROUTES.LOGIN);
      cy.get('[type="email"]').type(name + "@example.com");
      cy.get('[type="password"]').type(name);
      cy.get('[type="submit"]').contains("Sign in").click();
      cy.get('[href="#/profile/' + name + '"]').click();
      cy.wait(1000);
      cy.get(".article-preview").should("contain", "No articles");
    });
    it("should post a new article", () => {
      cy.visit(ROUTES.LOGIN);
      cy.get('[type="email"]').type(name + "@example.com");
      cy.get('[type="password"]').type(name);
      cy.get('[type="submit"]').contains("Sign in").click();
      cy.get('[aria-label="New Post"]').contains("New Post").click();
      cy.get('[placeholder="Article Title"]').type(name);
      cy.get('[placeholder="What\'s this article about?"]').type("content");
      cy.get('[placeholder="Write your article (in markdown)"]').type(
        "## test",
      );
      cy.get('[placeholder="Enter tags"]').type("butt");

      cy.get('[type="submit"]').click();
      cy.wait(1000);

      cy.url().should(
        "contain",
        "article/" + name.toLowerCase().replace(/ /g, "-"),
      );
      cy.get(".container > h1").should("contain", name);
    });
    it("should display the created article", () => {
      cy.visit(ROUTES.LOGIN);
      cy.get('[type="email"]').type(name + "@example.com");
      cy.get('[type="password"]').type(name);
      cy.get('[type="submit"]').contains("Sign in").click();
      cy.get('[aria-label="' + name + '"]').click();
      cy.get(".preview-link").should("contain", name);
    });
  });
});
