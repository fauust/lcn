CREATE TABLE contacts (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          nom VARCHAR(30) NOT NULL,
                          prenom VARCHAR(30) NOT NULL,
                          address TEXT NOT NULL,
                          code_postal VARCHAR(10) NOT NULL,
                          ville VARCHAR(50) NOT NULL
);

INSERT INTO contacts (nom, prenom, address, code_postal, ville) VALUES
    ('Dupont', 'Jean', '123 Rue de la Paix', '75001', 'Paris');
