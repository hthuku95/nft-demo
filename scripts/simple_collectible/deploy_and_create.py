from scripts.helpful_scripts import get_account,OPENSEA_URL
from brownie import SimpleCollectible

sample_token_uri = "ipfs://Qmd9MCGtdVz2miNumBHDbvj8bigSgTwnr4SbyH6DNnpWdt?filename=0-PUG.json"

def main():
    account = get_account()
    simple_collectible = SimpleCollectible.deploy({"from":account})
    print("SimpleCollectible Contract Deployed!")
    print("Creating collectible")
    tx = simple_collectible.createCollectible(
        sample_token_uri,
        {"from":account}
    )
    tx.wait(1)
    print(f"You can view your NFT at {OPENSEA_URL.format(simple_collectible.address, simple_collectible.tokenCounter() - 1)}")
