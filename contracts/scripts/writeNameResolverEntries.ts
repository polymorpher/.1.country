// Note: this is written for the very first version of D1DC. It is now deprecated. Please use dump.ts

import dotenv from 'dotenv'
import fs from 'fs/promises'
import { ethers } from 'hardhat'
import { Interface } from 'ethers/lib/utils'
import { NameResolver as NameResolverContract } from '../typechain-types/contracts/resolvers'

dotenv.config({ path: '.env.nr' })

const NAME_RESOLVER_CONTRACT = process.env.NAME_RESOLVER_CONTRACT || '0x0Ad7c7766aA67B46e4ba6Fd2905531fBE62c8Fc5'
const DUMP_FILE = process.env.DUMP_FILE || 'dump.json'
const ABI_FILE = process.env.ABI_FILE || './abi/NameResolver.json'

async function main () {
  const abi = await fs.readFile(ABI_FILE, { encoding: 'utf-8' })
  const signer = await ethers.getNamedSigner('deployer')
  // @ts-ignore
  const c:NameResolverContract = new ethers.Contract(NAME_RESOLVER_CONTRACT, new Interface(abi), signer)
  if (!await c.hasRole(await c.MANAGER_ROLE(), signer.address)) {
    const tx = await c.setupManager(signer.address)
    await tx.wait()
    console.log(`[tx=${tx.hash}] Set up manager for ${signer.address}`)
  }

  const records:{name:string, key: string, record: [string, number, string, string]}[] = JSON.parse(await fs.readFile(DUMP_FILE, { encoding: 'utf-8' }))
  for (const r of records) {
    const currentName = await c.nameOf(r.record[0])
    if (currentName) {
      console.log(`Ignoring [${r.name}] for ${r.record[0]} - name already set to ${currentName}`)
      continue
    }
    const tx = await c.setName(r.record[0], r.name)
    await tx.wait()
    console.log(`[tx=${tx.hash}] Set name [${r.name}] for ${r.record[0]}`)
  }
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
