// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

/// A decentralized journal application on Sui blockchain.
/// Users can create personal journals and add timestamped entries.
module journal::journal {
    use std::string::String;
    use sui::clock::Clock;

    /// A journal owned by a user containing multiple entries
    public struct Journal has key, store {
        id: UID,
        owner: address,
        title: String,
        entries: vector<Entry>,
    }

    /// A journal entry with content and timestamp
    public struct Entry has store {
        content: String,
        create_at_ms: u64,
    }

    /// Create and return a new Journal object with an empty entries vector
    public fun new_journal(title: String, ctx: &mut TxContext): Journal {
        Journal {
            id: object::new(ctx),
            owner: ctx.sender(),
            title,
            entries: vector::empty<Entry>(),
        }
    }

    /// Add a new entry to the journal
    /// Verifies the caller is the journal owner
    public fun add_entry(
        journal: &mut Journal, 
        content: String, 
        clock: &Clock, 
        ctx: &TxContext
    ) {
        // Verify the caller is the journal owner
        assert!(journal.owner == ctx.sender(), 0);
        
        // Create a new entry with current timestamp
        let entry = Entry {
            content,
            create_at_ms: clock.timestamp_ms(),
        };
        
        // Add the entry to the journal's entries vector
        journal.entries.push_back(entry);
    }
}