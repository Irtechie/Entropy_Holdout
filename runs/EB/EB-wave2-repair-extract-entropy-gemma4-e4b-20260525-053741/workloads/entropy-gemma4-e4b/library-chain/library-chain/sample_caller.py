from library_chain.chain.chain import chain_processor

def main():
    # Use the new chain library which depends on feature and core
    message = chain_processor.execute_chain("Entropy User")
    print(message)

if __name__ == "__main__":
    main()
