require 'sqlite3'

def add_into_db(block)
  begin
    db = SQLite3::Database.open 'test.db'

    # Ajout du bloc dans la table 'Blocks'
    query_block = "INSERT INTO Blocks VALUES('#{block.index}', '#{block.timestamp}', '#{block.proof}', '#{block.previous_hash}', '#{block.hash}')"
    db.execute query_block


    block.data.each do |transaction|

      transaction.each do |datas|
        query_transaction = "INSERT INTO Transactions VALUES('#{block.index}', '#{datas.sender}', '#{datas.receiver}', '#{datas.amount}')"
        db.execute query_transaction
      end

    end


    puts 'Block and transactions successfully added into sqlite3'
  rescue SQLite3::Exception => e
    puts 'Unexpected error. Please verify the database state or the query.'
    puts "Error : #{e}"
  ensure
    db.close if db
  end
end

def get_last
  begin
  db = SQLite3::Database.open 'test.db'
  query = 'SELECT * FROM Blocks WHERE ID = (SELECT MAX(ID) FROM Blocks)'
  result = db.execute query
  Block.new(result[0][0], result[0][1], result[0][2], result[0][3], result[0][4])
  rescue SQLite3::Exception => e
    puts 'Could not load last block in database. Please check the following message for more information : '
    puts "Error : #{e}"
  ensure
    db.close if db
  end
end