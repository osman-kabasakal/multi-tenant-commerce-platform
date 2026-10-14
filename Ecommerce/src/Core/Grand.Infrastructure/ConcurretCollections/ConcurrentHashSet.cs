using System;
using System.Collections;
using System.Collections.Concurrent;
using System.Diagnostics;

namespace Grand.Infrastructure.ConcurretCollections;

/// <summary>
    /// Represents a thread-safe set of values.
    /// </summary>
    /// <typeparam name="T">The type of elements in the set.</typeparam>
    [DebuggerDisplay("Count = {Count}")]
    public class ConcurrentHashSet<T> : IReadOnlyCollection<T>, ICollection<T>
    {
        private readonly ConcurrentDictionary<T, bool> _dictionary;

        /// <summary>
        /// Initializes a new instance of the <see cref="ConcurrentHashSet{T}"/> class.
        /// </summary>
        public ConcurrentHashSet()
        {
            _dictionary = new ConcurrentDictionary<T, bool>();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ConcurrentHashSet{T}"/> class
        /// that contains elements copied from the specified collection.
        /// </summary>
        /// <param name="collection">The collection whose elements are copied to the new set.</param>
        public ConcurrentHashSet(IEnumerable<T> collection)
        {
            if (collection == null) throw new ArgumentNullException(nameof(collection));
            _dictionary = new ConcurrentDictionary<T, bool>();
            
            foreach (var item in collection)
            {
                _dictionary.TryAdd(item, true);
            }
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ConcurrentHashSet{T}"/> class 
        /// that uses the specified <see cref="IEqualityComparer{T}"/>.
        /// </summary>
        /// <param name="comparer">
        /// The <see cref="IEqualityComparer{T}"/> implementation to use when 
        /// comparing objects.
        /// </param>
        public ConcurrentHashSet(IEqualityComparer<T> comparer)
        {
            _dictionary = new ConcurrentDictionary<T, bool>(comparer);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ConcurrentHashSet{T}"/> class
        /// that contains elements copied from the specified collection and uses 
        /// the specified <see cref="IEqualityComparer{T}"/>.
        /// </summary>
        /// <param name="collection">The collection whose elements are copied to the new set.</param>
        /// <param name="comparer">
        /// The <see cref="IEqualityComparer{T}"/> implementation to use when 
        /// comparing objects.
        /// </param>
        public ConcurrentHashSet(IEnumerable<T> collection, IEqualityComparer<T> comparer)
        {
            if (collection == null) throw new ArgumentNullException(nameof(collection));
            _dictionary = new ConcurrentDictionary<T, bool>(comparer);
            
            foreach (var item in collection)
            {
                _dictionary.TryAdd(item, true);
            }
        }

        /// <summary>
        /// Gets the <see cref="IEqualityComparer{T}"/> object that is used to determine 
        /// equality for the values in the set.
        /// </summary>
        public IEqualityComparer<T> Comparer => _dictionary.Comparer;

        /// <summary>
        /// Gets the number of elements contained in the <see cref="ConcurrentHashSet{T}"/>.
        /// </summary>
        public int Count => _dictionary.Count;

        /// <summary>
        /// Gets a value indicating whether the <see cref="ConcurrentHashSet{T}"/> is read-only.
        /// </summary>
        public bool IsReadOnly => false;

        /// <summary>
        /// Adds the specified item to the <see cref="ConcurrentHashSet{T}"/>.
        /// </summary>
        /// <param name="item">The item to add.</param>
        /// <returns>true if the item was added to the <see cref="ConcurrentHashSet{T}"/>; 
        /// false if the item already exists.</returns>
        public bool Add(T item)
        {
            return _dictionary.TryAdd(item, true);
        }

        /// <summary>
        /// Removes all items from the <see cref="ConcurrentHashSet{T}"/>.
        /// </summary>
        public void Clear()
        {
            _dictionary.Clear();
        }

        /// <summary>
        /// Determines whether the <see cref="ConcurrentHashSet{T}"/> contains the specified item.
        /// </summary>
        /// <param name="item">The item to locate in the <see cref="ConcurrentHashSet{T}"/>.</param>
        /// <returns>true if the <see cref="ConcurrentHashSet{T}"/> contains the specified item; otherwise, false.</returns>
        public bool Contains(T item)
        {
            return _dictionary.ContainsKey(item);
        }

        /// <summary>
        /// Copies the elements of the <see cref="ConcurrentHashSet{T}"/> to an array, starting at the specified array index.
        /// </summary>
        /// <param name="array">
        /// The one-dimensional array that is the destination of the elements copied from the <see cref="ConcurrentHashSet{T}"/>.
        /// </param>
        /// <param name="arrayIndex">The zero-based index in array at which copying begins.</param>
        public void CopyTo(T[] array, int arrayIndex)
        {
            if (array == null) throw new ArgumentNullException(nameof(array));
            if (arrayIndex < 0) throw new ArgumentOutOfRangeException(nameof(arrayIndex));
            if (array.Length - arrayIndex < Count) throw new ArgumentException("The number of elements in the source collection is greater than the available space from arrayIndex to the end of the destination array.");

            int i = arrayIndex;
            foreach (var kvp in _dictionary)
            {
                array[i++] = kvp.Key;
            }
        }

        /// <summary>
        /// Returns an enumerator that iterates through the <see cref="ConcurrentHashSet{T}"/>.
        /// </summary>
        /// <returns>An enumerator for the <see cref="ConcurrentHashSet{T}"/>.</returns>
        public IEnumerator<T> GetEnumerator()
        {
            foreach (var kvp in _dictionary)
            {
                yield return kvp.Key;
            }
        }

        /// <summary>
        /// Returns an enumerator that iterates through the <see cref="ConcurrentHashSet{T}"/>.
        /// </summary>
        /// <returns>An enumerator for the <see cref="ConcurrentHashSet{T}"/>.</returns>
        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        /// <summary>
        /// Removes the specified item from the <see cref="ConcurrentHashSet{T}"/>.
        /// </summary>
        /// <param name="item">The item to remove.</param>
        /// <returns>true if the item was removed from the <see cref="ConcurrentHashSet{T}"/>; 
        /// otherwise, false. This method also returns false if item was not found in the original <see cref="ConcurrentHashSet{T}"/>.</returns>
        public bool Remove(T item)
        {
            return _dictionary.TryRemove(item, out _);
        }

        /// <summary>
        /// Adds the specified item to the <see cref="ConcurrentHashSet{T}"/> if it does not already exist.
        /// </summary>
        /// <param name="item">The item to add.</param>
        /// <returns>true if the item was added to the <see cref="ConcurrentHashSet{T}"/>; 
        /// false if the item already exists.</returns>
        // bool ICollection<T>.Add(T item)
        // {
        //     return Add(item);
        // }

        /// <summary>
        /// Determines whether the <see cref="ConcurrentHashSet{T}"/> contains all elements in the specified collection.
        /// </summary>
        /// <param name="other">The collection to compare to the current <see cref="ConcurrentHashSet{T}"/>.</param>
        /// <returns>true if the <see cref="ConcurrentHashSet{T}"/> is a subset of other; otherwise, false.</returns>
        public bool IsSubsetOf(IEnumerable<T> other)
        {
            if (other == null) throw new ArgumentNullException(nameof(other));

            // If this set has more elements than the other collection, then it can't be a subset
            if (other is ICollection<T> otherAsCollection && Count > otherAsCollection.Count)
                return false;

            // Create a set from the other collection for efficient lookups
            HashSet<T> otherSet = new HashSet<T>(other, Comparer);
            
            // Check if all elements in this set exist in the other set
            foreach (var item in this)
            {
                if (!otherSet.Contains(item))
                    return false;
            }
            
            return true;
        }

        /// <summary>
        /// Determines whether the <see cref="ConcurrentHashSet{T}"/> and the specified collection contain the same elements.
        /// </summary>
        /// <param name="other">The collection to compare to the current <see cref="ConcurrentHashSet{T}"/>.</param>
        /// <returns>true if the <see cref="ConcurrentHashSet{T}"/> is equal to other; otherwise, false.</returns>
        public bool SetEquals(IEnumerable<T> other)
        {
            if (other == null) throw new ArgumentNullException(nameof(other));

            // If the other collection is also a set with the same count, we can do a quick check
            if (other is ICollection<T> otherAsCollection && Count != otherAsCollection.Count)
                return false;

            // Create a copy of this set to track which elements we've seen
            HashSet<T> elements = new HashSet<T>(this, Comparer);
            
            // Check if all elements in the other collection exist in this set
            // and mark them as seen
            foreach (var item in other)
            {
                if (!elements.Remove(item))
                    return false;
            }
            
            // If all elements in other were found in this set and all elements
            // in this set were found in other, then elements should be empty
            return elements.Count == 0;
        }

        /// <summary>
        /// Modifies the current <see cref="ConcurrentHashSet{T}"/> to contain only elements that are also in the specified collection.
        /// </summary>
        /// <param name="other">The collection to compare to the current <see cref="ConcurrentHashSet{T}"/>.</param>
        public void IntersectWith(IEnumerable<T> other)
        {
            if (other == null) throw new ArgumentNullException(nameof(other));

            // Create a set from the other collection for efficient lookups
            HashSet<T> otherSet = new HashSet<T>(other, Comparer);
            
            // Remove all elements from this set that are not in the other set
            foreach (var item in this.ToArray())
            {
                if (!otherSet.Contains(item))
                    Remove(item);
            }
        }

        /// <summary>
        /// Modifies the current <see cref="ConcurrentHashSet{T}"/> to contain all elements that are in the current set, in the specified collection, or in both.
        /// </summary>
        /// <param name="other">The collection to compare to the current <see cref="ConcurrentHashSet{T}"/>.</param>
        public void UnionWith(IEnumerable<T> other)
        {
            if (other == null) throw new ArgumentNullException(nameof(other));

            // Add all elements from the other collection to this set
            foreach (var item in other)
            {
                Add(item);
            }
        }

        /// <summary>
        /// Modifies the current <see cref="ConcurrentHashSet{T}"/> to contain all elements that are in the current set but not in the specified collection.
        /// </summary>
        /// <param name="other">The collection to compare to the current <see cref="ConcurrentHashSet{T}"/>.</param>
        public void ExceptWith(IEnumerable<T> other)
        {
            if (other == null) throw new ArgumentNullException(nameof(other));

            // Remove all elements from this set that are in the other collection
            foreach (var item in other)
            {
                Remove(item);
            }
        }

        /// <summary>
        /// Attempts to add the specified item to the <see cref="ConcurrentHashSet{T}"/>.
        /// </summary>
        /// <param name="item">The item to add.</param>
        /// <returns>true if the item was added to the <see cref="ConcurrentHashSet{T}"/>; 
        /// false if the item already exists.</returns>
        public bool TryAdd(T item)
        {
            return _dictionary.TryAdd(item, true);
        }

        /// <summary>
        /// Attempts to remove the specified item from the <see cref="ConcurrentHashSet{T}"/>.
        /// </summary>
        /// <param name="item">The item to remove.</param>
        /// <returns>true if the item was removed from the <see cref="ConcurrentHashSet{T}"/>; 
        /// otherwise, false. This method also returns false if item was not found in the original <see cref="ConcurrentHashSet{T}"/>.</returns>
        public bool TryRemove(T item)
        {
            return _dictionary.TryRemove(item, out _);
        }

    // System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
    // {
    //     return GetEnumerator();
    // }

    void ICollection<T>.Add(T item)
    {
        Add(item);
    }
}
